Return-Path: <linux-kernel-owner+w=401wt.eu-S1752918AbZGVJxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbZGVJxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 05:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbZGVJxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 05:53:36 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:37392 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbZGVJxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 05:53:36 -0400
Date: Wed, 22 Jul 2009 11:54:37 +0200
From: Bastian Blank <bastian@waldi.eu.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [PATCH] x86: detect use of extended APIC ID for AMD CPUs
Message-ID: <20090722095436.GA9000@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	xen-devel@lists.xensource.com
References: <20090604104016.GT5736@alberich.amd.com> <20090721103642.GA10071@wavehammer.waldi.eu.org> <4A65F34D.40506@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4A65F34D.40506@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 09:56:45AM -0700, Jeremy Fitzhardinge wrote:
> Does this work?  (Completely untested.)

Yes, it works. It just looks like a workaround.

Bastian

-- 
Each kiss is as the first.
		-- Miramanee, Kirk's wife, "The Paradise Syndrome",
		   stardate 4842.6
