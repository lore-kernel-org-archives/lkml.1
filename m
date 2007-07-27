Return-Path: <linux-kernel-owner+w=401wt.eu-S932469AbXG0Ad0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbXG0Ad0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 20:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758288AbXG0AdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 20:33:19 -0400
Received: from rs19.luxsci.com ([65.61.136.23]:56296 "EHLO rs19.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755597AbXG0AdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 20:33:19 -0400
Message-ID: <46A93D4E.5070405@invtools.com>
Date: Thu, 26 Jul 2007 19:33:18 -0500
From: Jon Hedlund <JonH@invtools.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: solved - eth device going missing
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Further Googling revealed the cause was my /etc/iftab file.
Sorry for bothering the list, the problems I have been having with acpi 
and the Q965 express chipset had me thinking this was a related issue.

JonH

