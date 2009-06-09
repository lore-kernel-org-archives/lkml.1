Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbZFIOdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbZFIOdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 10:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbZFIOdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 10:33:11 -0400
Received: from netrider.rowland.org ([192.131.102.5]:59639 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751467AbZFIOdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 10:33:10 -0400
Date: Tue, 9 Jun 2009 10:33:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM:
 Rearrange core suspend code)
In-Reply-To: <200906090925.18866.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0906091032260.28447-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009, Oliver Neukum wrote:

> But the problem here is STR or STD. How do you notify drivers that the BIOS
> has resumed their device instead of autoresume() being called? A driver
> has to know that its device has become active without its knowledge.

That would be a wonderful contradiction in terms.  :-)

Alan Stern

