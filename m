Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbXIMMh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbXIMMh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 08:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbXIMMhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 08:37:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:17048 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbXIMMhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 08:37:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dDKq50JhA2tp4EDXeHEDZD3IzFS4bPxYQBrPb6wzefZp+T0PeboRWny/GYNrcLUmjrjR6B5gr4mDqd6MyAFcYCIq/Y7/Ho6lPvdvOmPAw9/s3LXmiCa+dB+HWzLt/EKEngO37d7imMqJOb4SWd2rnu4Q742KXi6Pk8ieG7AxfM4=
Message-ID: <f405816b0709130537u2e038053tca1a96f6711952f8@mail.gmail.com>
Date: Thu, 13 Sep 2007 20:37:16 +0800
From: "Frank Liu" <frank.liu64@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [linux-kernel]how to get the latest kernel source tree?
In-Reply-To: <f405816b0709130534k11fc5ca0r4f9ac1f0ea9725e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f405816b0709130534k11fc5ca0r4f9ac1f0ea9725e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason I was not able to use git, but I still wanna get the
latest kernel source tree as I hope to submit a patch, hence I am now
about to do the things like this:

-download kernel 2.6.22.6 as this is the latest stable version
-and download patch-2.6.23-rc6.bz2 and decompressed it
-apply patch-2.6.23-rc6 against 2.6.22.6 source tree

Is this reasonable?
Thanks

Regards
Frank
