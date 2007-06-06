Return-Path: <linux-kernel-owner+w=401wt.eu-S933873AbXFFQJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933873AbXFFQJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932226AbXFFQJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:09:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59207 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765801AbXFFQJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:09:15 -0400
Message-ID: <4666DC25.9050801@redhat.com>
Date: Wed, 06 Jun 2007 12:09:09 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Silla Rizzoli <biker@ngi.it>
CC: linux-kernel@vger.kernel.org
Subject: Re: No sound from Lenovo 3000 N100
References: <200706061747.42559.biker@ngi.it>
In-Reply-To: <200706061747.42559.biker@ngi.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2007 11:47 AM, Silla Rizzoli wrote:
> I've just tried 2.6.22-rc4 and sound doesn't work. It has never worked before, 
> unless I disable ACPI.
> 

Contents of /proc/interrupts might help.
