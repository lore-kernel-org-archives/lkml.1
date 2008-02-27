Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbYB0M1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbYB0M1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 07:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbYB0M1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 07:27:46 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:45651 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbYB0M1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 07:27:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mCo+ZvccUYQENznYNjYH9KyU4jHDrtZVp0621BMAoiqry3l0D3O8qEgZLzQVUqW1S+UecgVLKKh3WqMp6sK8RnrsURqvs3WCRyjaChUxLGnHkiG1NoSVhn3wRfPuDyfQ8zZStCVYXzBWVqQSSxkI+M5AioA6VM036AMAMf1+hks=
Message-ID: <5d75f4610802270427y789ffae9ie2682059206eed51@mail.gmail.com>
Date: Wed, 27 Feb 2008 19:27:44 +0700
From: "BuraphaLinux Server" <buraphalinuxserver@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: at program breaks with kernel 2.6.24
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=463669

I have the same problem - it is not debian specific.  Did the
semantics of kill() change with the new kernel?  I thought as long as
something is setuid, even with capability stuff around the setuid
programs just get _all_ capabilities and would keep working.

I did a good search and found many people with the problem, but no
solutions except going back to 2.6.23.x kernels.  I guess you'll flame
me, but at least include a link to the solution too.
