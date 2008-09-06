Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbYIFJJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbYIFJJY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 05:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbYIFJJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 05:09:17 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:64309 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150AbYIFJJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 05:09:16 -0400
Message-ID: <48C248B9.6010805@superbug.co.uk>
Date: Sat, 06 Sep 2008 10:09:13 +0100
From: James Courtier-Dutton <James@superbug.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080727)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Uniquely identify and Motherboard Model.
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there a way I could uniquely identify a Motherboard Model. I don't
need the serial number, just the model.
Applications for this could be:
1) Create a table to map Motherboard Model to lmsensors calibration
settings. All motherboards seem to use different resistors, so the
calibration needs to be adjusted for each motherboard model.
2) Sound card in/out wiring.
3) Any other wiring on the motherboard that one needs to know, but
cannot identify through other means.

It might be useful for the kernel to provide this as a service so that
driver modules can use it to make choices.


Kind Regards

James
