Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbYGVVcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbYGVVcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 17:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYGVVcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 17:32:45 -0400
Received: from smtp.daktronics.com ([63.85.214.24]:4963 "HELO
	smtp.daktronics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753244AbYGVVcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 17:32:45 -0400
X-Greylist: delayed 2220 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jul 2008 17:32:45 EDT
Subject: map keyboard to stdin
From: Kevin Holland <khollan@daktronics.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 22 Jul 2008 15:55:27 -0500
Message-Id: <1216760127.6242.18.camel@kevin-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I have an embedded Linux board that uses 2.6.21, the console is output
the serial port.  How can I set it up so a USB keyboard will be accepted
as input as well as anything received from the serial port and it will
be echoed to the output of the serial port as well.  Basically I want to
issue commands either through a terminal program to the embedded board
or a USB keyboard that is connected to the board, but I still want to
see what was typed on the keyboard out the serial terminal. I have
enabled USB HID support in the Kernel as well.

I was told from another message list that somebody might have done this
here about a year ago, but I couldn't find anything in the archives.

Thanks for your help and please CC khollan@daktronics.com as I'm not a
subscriber to the list yet.

Kevin
