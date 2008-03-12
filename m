Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbYCLSOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbYCLSOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 14:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbYCLSOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 14:14:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:35371 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbYCLSOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 14:14:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=G+GNMvX6N6y8rRCu0lGl2Z+WVboudN/QB5E1J4gcSHfaulsQDISLp2AACaaPGfUOd9C/Dtu3B2JultMLYEbrFX/u48SjIsEnRsvEICRmFycbqYTma5kVRJevJ5QFxXoBMEp5Ran+mQGx0o8KGM3oWUtZcRXdqMq790U2tWpoOIA=
Message-ID: <47D81D6E.9080701@gmail.com>
Date: Wed, 12 Mar 2008 19:14:06 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: npiggin@suse.de, linux-kernel@vger.kernel.org
Subject: linux+glibc memory allocator, poor performance
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

More tests from FreeBSD people <http://people.freebsd.org/~kris/scaling/smp.html>

Poor performance with 2.6.24 linux kernel and glibc 2.7 provided by Fedora 8:

*Memory allocation performance on FreeBSD and Linux with ebizzy (Mar 2008)*
<http://people.freebsd.org/~kris/scaling/ebizzy.html>


-thanks-

regards,
-- 
so much to do, so little time.

