Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbZGJTJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbZGJTJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 15:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755152AbZGJTJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 15:09:03 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38994 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752440AbZGJTJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 15:09:01 -0400
Date: Fri, 10 Jul 2009 15:09:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: K R I S K <kdbbox@gmail.com>
cc: Miklos Szeredi <miklos@szeredi.hu>, <linux-usb@vger.kernel.org>,
       <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: usb mouse not responding after resume
In-Reply-To: <12e16730907101144y57d5b348n9be6c2d37d7ad764@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0907101507480.4183-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009, K R I S K wrote:

> How many USB devices are attached along with the mouse?
> Are they high speed and full speed devices?

If you read through Miklos's log extract you'll see that there are two 
other devices: one full speed and one low speed.

Alan Stern

