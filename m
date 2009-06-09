Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbZFIOrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbZFIOrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 10:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbZFIOrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 10:47:23 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:37978 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbZFIOrX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 10:47:23 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Tue, 9 Jun 2009 16:48:09 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906091032260.28447-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906091032260.28447-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906091648.09659.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 9. Juni 2009 16:33:12 schrieb Alan Stern:
> On Tue, 9 Jun 2009, Oliver Neukum wrote:
> > But the problem here is STR or STD. How do you notify drivers that the
> > BIOS has resumed their device instead of autoresume() being called? A
> > driver has to know that its device has become active without its
> > knowledge.
>
> That would be a wonderful contradiction in terms.  :-)

A practical application of the uncertainty principle in quantum computing.

But you have to notify a driver if you notice that a device's power state
has been changed without the knowledge of its driver.

	Regards
		Oliver

