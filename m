Return-Path: <linux-kernel-owner+w=401wt.eu-S932932AbXG0TLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932AbXG0TLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 15:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761949AbXG0TLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 15:11:12 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:2416 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761731AbXG0TLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 15:11:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=K5ify5XeYXbFDOE/wtu9T1OugMC9Gbwoea31WtvtHRAmyHF3cWiBbLa5gx+ddpcEDEkKTjrAJPiAmLOalDZssz/xtcg3RL1eFlEW/Dqc1soC72aAmhINbudRB8uG5DPHrzKc2MLHfEn8XBhHigzu1rNvH98tbAKT5pzi0a6XR5w=
Message-ID: <7fedbc910707271211v2ac2c927k3dd8fec8643ee250@mail.gmail.com>
Date: Fri, 27 Jul 2007 21:11:09 +0200
From: shacky <shacky83@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel modules compilation
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

During the Linux kernel compilation, I need to compile some modules
which are necessary for the system boot.
I localized these modules analyzing the modules which are
automatically loaded at the startup of my Debian system whith the
standard Debian kernel, through the output of the "lsmod" command.
I tried to search for these modules in the "menuconfig" kernel
configuration program, but I cannot find some of them, not even
searching in the .config file.

How I can find what items in "menuconfig" I need to activate (marking
it with "m") to compile the modules I need for the system startup?

Thank you very much for your help!
Bye.
