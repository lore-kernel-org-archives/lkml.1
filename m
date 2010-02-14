Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab0BNSkn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 13:40:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:24660 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab0BNSkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 13:40:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=umksr3XjkmbQjnw/3aJiT1rVTsQr5Gbkm5LQKAcEH/WOVxepI3xStY/fQWlY8PsKsc
         9yiq9SxeLYU5TOUP+b3iOkkxef6E/+v+kZWEVBzva2S8MN5wSoXa81QGj5AVrB4id7/+
         g6eTpe4nD9KcltIy8S5qOQkA/aEv0IVPlEJhM=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Linux mdadm superblock question.
Date: Sun, 14 Feb 2010 19:40:35 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.31.12r4; KDE/4.4.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
References: <201002140251.59668.volkerarmin@googlemail.com> <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
In-Reply-To: <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002141940.35716.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sonntag 14 Februar 2010, you wrote:

> 
> In other words, 'auto-detection' for 1.x format devices is using an
> initrd/initramfs.

which makes 1.x format useless for everybody who does not want to deal with 
initrd/initramfs.

Glück Auf,
Volker
