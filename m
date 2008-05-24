Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbYEXPgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbYEXPgR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 11:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYEXPgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 11:36:00 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58941 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbYEXPgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 11:36:00 -0400
Message-ID: <483835DD.3060304@garzik.org>
Date: Sat, 24 May 2008 11:35:57 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andras Mantia <amantia@kde.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: libata (pata_via) timeouts causing unusable device: the famous
 DRDY issue?
References: <200805232201.51701.amantia@kde.org> <48372989.3000700@garzik.org> <200805241612.29985.amantia@kde.org>
In-Reply-To: <200805241612.29985.amantia@kde.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andras Mantia wrote:
> On Friday 23 May 2008, Jeff Garzik wrote:
>> Have you tried all of: pci=nomsi, acpi=off, or noapic?
> 
> 
> So far:
> pci=nomsi does not help
> pci=nomsi acpi=off noapic works
> pci=nomsi noapic also works
> 
> I will try noapic only as well and report.

Generally you only want to use one of those...

	Jeff



