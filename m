Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817AbYLUDaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbYLUDaL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 22:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbYLUD36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 22:29:58 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:8029 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYLUD35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 22:29:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=QbeUsTyY7V0nY/ybiPx4uuQuRw/LyeHRf5Us9Qy0NFhciv6XG0LqUMizDGFWMsbH96
         BVjSRcT27QCKaQuKFhFpsTEirODjcaRwaedKv4hCsEElZn5+AQVTYDYwduj0YUmyCwM8
         XYqSQUK7Eo6pmsv/XHv+9N/i2dSinoFsKG5kc=
Date: Sun, 21 Dec 2008 11:27:46 +0800
From: arrow.ebd@gmail.com
To: linux_kernel <linux-kernel@vger.kernel.org>
Cc: frank@kingswood-consulting.co.uk
Subject: usb-serial: how to let ch341 work with baudrate 57600 ?
Message-ID: <20081221032746.GA4502@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dear frank,

	I have a USB-to-RS232 connector with chip ch341, but it
can not work under baud rate 57600.

	I checked baud rate is set in function "ch341_set_baudrate".

	How can I setup it with baudrate 57600 ?

	I would like hear from you, Or give me some suggestion
to hack it.

						Thanks
