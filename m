Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbZDWKME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbZDWKME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 06:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbZDWKLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 06:11:53 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:65472 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbZDWKLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 06:11:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:subject:date:mime-version:content-type
         :content-transfer-encoding:x-priority:x-msmail-priority:x-mailer
         :x-mimeole;
        b=TYgVbqV3KdtAPmDw/R+YHBmJd/JW9pr48FRQuq48xLoubkS+o4MwwK7IkJzm2n4l1N
         72i3PDBGi5AE9wHz8p3xjf/urOz9ul6srIGu+pOWKRnKGecNvcAMc7HtMfF8q5ah65Mu
         +Q2iTLnro6yQefuhFTahLabEjc5N+tcNsUYn4=
Message-ID: <7398C9BACDA74507AA9FCCCE4847C5A4@avitech.sk>
From: "Peter Hanzel" <hanzelpeter@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fbdev-devel@lists.sourceforge.net>
Subject: DRM KMS + intel fb
Date: Thu, 23 Apr 2009 12:12:15 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I am watching the KMS in DRM development. And now i want to try kernel 
modesetting with framebuffer console.
I am only using console framebuffer. How it works with DRM KMS.

Suppose I compile DRM i1915 with KMS. How can I swich video mode on start 
and than from user space.
Normally with framebuffer it is IOCTL on /dev/fb.  Will it work or not?

Some explantion should ne enough, thanks 

