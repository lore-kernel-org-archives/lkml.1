Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbZFEPNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbZFEPNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 11:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbZFEPNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 11:13:34 -0400
Received: from netrider.rowland.org ([192.131.102.5]:58830 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751988AbZFEPNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 11:13:34 -0400
Date: Fri, 5 Jun 2009 11:13:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Corentin Chary <corentin.chary@gmail.com>,
       <acpi4asus-user@lists.sourceforge.net>, <len.brown@intel.com>,
       <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
In-Reply-To: <4A2931F5.1090709@tuffmail.co.uk>
Message-ID: <Pine.LNX.4.44L0.0906051112370.10297-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009, Alan Jenkins wrote:

> Auto-suspend white-listing would be done on the basis of USB ids 
> (vendor, product).  At the moment it's expected that userspace should 
> take ownership of it.  There's no infrastructure for in-kernel 
> whitelisting.  I think.

That's right.  We found it was hopeless to try doing this in the kernel 
so we dumped the whole mess into userspace.

Alan Stern

