Return-Path: <linux-kernel-owner+w=401wt.eu-S1761209AbZFPWST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761209AbZFPWST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 18:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756430AbZFPWSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 18:18:09 -0400
Received: from outbound-mail-302.bluehost.com ([67.222.53.9]:55043 "HELO
	outbound-mail-302.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755408AbZFPWSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 18:18:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=jNPfLoHl41jhpFwtzUC2tQHbtXOjFFeLxvUJ3ARASkRWvreitBs5Kj8EZQHSKJj5BE7kkWmSu70eD84BTz5EGG9YuwvR9LAwr2tXhug2kKevwUCN1Zx7Xtb4WFKQ5k7r;
Date: Tue, 16 Jun 2009 15:18:04 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] IDE: consistently use type bool for wake enable
 variable
Message-ID: <20090616151804.0ea89caa@jbarnes-g45>
In-Reply-To: <200906170016.16716.elendil@planet.nl>
References: <20090616142554.7bce02f6@jbarnes-g45>
	<200906170016.16716.elendil@planet.nl>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009 00:16:15 +0200
Frans Pop <elendil@planet.nl> wrote:

> IDE: consistently use type bool for wake enable parameter
> 
> Other functions use type bool, so use that for pci_enable_wake as
> well.
> 
> Signed-off-by: Frans Pop <elendil@planet.nl>
> ---
> 
> Hi Jesse,
> 
> I've had this trivial patch sitting in my local branch for some time.
> Please consider including.

Yep, looks reasonable.  Rafael I assume there's no objection here?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
