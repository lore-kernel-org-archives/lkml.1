Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbYJCJ6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbYJCJ6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 05:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYJCJ6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 05:58:00 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:21275 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbYJCJ57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 05:57:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=tt4voe8ua4u4pFx69LT5/xojE0E6OqbIXoDzlSw9g5UVL7NcjuHLwa/cfgTIKnrJFz
         swYNJCqm0AGy3/McXoghGQXTaZFHlcL4EcTQNkJnTr2xc4quocUe62dNHFt4XvJOhN9W
         u2oELGttzD3OkBSYfjXIgneNGmSKWcE+xmTWs=
Message-ID: <64630f150810030257l6ac7c82fw4e38588d4ec8a1bf@mail.gmail.com>
Date: Fri, 3 Oct 2008 10:57:56 +0100
From: gettinther <gettinther@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: edd breaking vesafb
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any news on this subject?

http://www.uwsg.iu.edu/hypermail/linux/kernel/0809.2/0890.html

I am still getting the issue with the 2.6.27.rc8 kernel.  I use
bootsplash and the only way for vesafb to work is to disable edd.
