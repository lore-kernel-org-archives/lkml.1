Return-Path: <linux-kernel-owner+w=401wt.eu-S2992966AbXEBJxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992966AbXEBJxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 05:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992980AbXEBJxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 05:53:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:36403 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992966AbXEBJxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 05:53:36 -0400
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Olivier Galibert <galibert@pobox.com>
Subject: Re: [PATCH] mmconfig: Some additional chipset register values validation.
Date: Wed, 2 May 2007 11:52:36 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, greg@kroah.com,
       jesse.barnes@intel.com
References: <20070502005011.GA41935@dspnet.fr.eu.org>
In-Reply-To: <20070502005011.GA41935@dspnet.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705021152.36648.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 May 2007 02:50:11 Olivier Galibert wrote:
> On i945, a mmconfig range hitting the f0000000-ffffffff zone conflicts
> with the APIC registers and others.  Consider it invalid.
> 
> On E7520, values 0000 and f000 for the window register are defined
> invalid in the documentation.

Added thanks

-Andi
