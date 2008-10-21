Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbYJUUCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbYJUUCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbYJUUCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:02:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45435 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752303AbYJUUCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:02:09 -0400
Date: Tue, 21 Oct 2008 16:02:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>
Subject: Re: Oops in UHCI when encountering "host controller process error"
In-Reply-To: <48F7E3B8.2090106@goop.org>
Message-ID: <Pine.LNX.4.44L0.0810211601340.2353-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008, Jeremy Fitzhardinge wrote:

> Looks like this is the relevent detail: "uhci->skelqh[1]->node.next is 
> NULL" for all the queues.  Haven't looked into it yet.

Any news?

Alan Stern

