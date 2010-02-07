Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065Ab0BGS4w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 13:56:52 -0500
Received: from mail-fx0-f211.google.com ([209.85.220.211]:52617 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab0BGS4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 13:56:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=kra135p7EL0zyklCAWQLXrAg2hYF/l5r4+/2KhRxl2h/eaLekDUra/IMzm0xG/QKF3
         xaPHwoQUV/2F5aFyIWiho6x0025FdEHbx7nZxQvKI3BzF0mGbYyW/czoDJAg2M3gnIIW
         EhPkpLz2sN/ZMpCeHQdoRHFWauEvwyUJ8kCJ0=
MIME-Version: 1.0
Date: Sun, 7 Feb 2010 13:56:47 -0500
Message-ID: <45c77aec1002071056re61b8acg5f480f8ea83c68c@mail.gmail.com>
Subject: Possible bug in insmod or the kernel?
From: Larry Homes <larr.homes@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am very new to kernel development and I was playing around with
making modules. I found I could not retrieve commandline parameters in
the module if the parameter has whitespace in it. I thought it was my
lack of knowledge that was causing the error (and I still do
honestly), but I made a forum post here
http://forum.kernelnewbies.org/read.php?17,1354 regarding the issue,
and someone suggested it may be a bug and I should post on LKML.

The forum post shows example code to demonstrate the issue. I am using
archlinux and the latest kernel. I am not sure what other information
you need, so feel free to ask for anything.


Thanks
