Return-Path: <linux-kernel-owner+w=401wt.eu-S1760519AbXGQLiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760519AbXGQLiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 07:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbXGQLhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 07:37:52 -0400
Received: from mail.suse.de ([195.135.220.2]:47826 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbXGQLhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 07:37:51 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Aaron Durbin <adurbin@google.com>
Subject: Re: [PATCH] x86_64: Make ACPI the default reset option
Date: Tue, 17 Jul 2007 13:32:31 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
References: <20070716180221.GA5370@google.com>
In-Reply-To: <20070716180221.GA5370@google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707171332.31519.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 July 2007 20:02:21 Aaron Durbin wrote:
> 
> Make ACPI be the default reset method for x86_64. If the reset mechanism fails
> using ACPI, it will default to using the keyboard controller.

Again why? 

You really can't just throw out these patches without any explanation.


-Andi
