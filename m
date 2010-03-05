Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab0CEGpd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 01:45:33 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55480 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab0CEGpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 01:45:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=KslfoXoibIj/xhZIMQBrvwxb2F8f5De0b6P6m352xT+K2IC/M47n7+MT7+ptnTYrly
         h2g7vUBXzHWMqEISNNWBKXFMGPVg3lGvps0LUSoQOL0J//ojCSpVYagU88wm6ro6hFwg
         rZeIRyAgRbdAErbLD1E98dehu+qj274ZR7I14=
MIME-Version: 1.0
Date: Fri, 5 Mar 2010 12:15:31 +0530
Message-ID: <b2ac5deb1003042245j2c8de603oa73a32eb98c7ab75@mail.gmail.com>
Subject: Help regarding the splitting of available screen size
From: Swapnil Pimpale <swapnil.pict@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
      I am working on a project which requires the kernel to use only
half of screen. Other half of the screen will be used for some other
purpose. I will be running the kernel in text mode. I tried to do some
changes to file drivers/console/vgacon.c to achieve this.
      I changed the value of vga_video_num_lines to half of its value, but
that didn't work for me.
      I am using the linux kernel version 2.6.24.7 for my project.

Could anyone please suggest me any pointers for implementing this .

Thanks,
Swapnil Pimpale
