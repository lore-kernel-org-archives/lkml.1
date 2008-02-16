Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbYBPJl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbYBPJl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 04:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbYBPJlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 04:41:17 -0500
Received: from an-out-0708.google.com ([209.85.132.240]:31964 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbYBPJlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 04:41:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BrMyrqHsfbsDzQWUKf74iciXGjE5i1G9jXc7vTR8k+albpeYSO+1GTUL708elytBMG+PG2c8nVzQRLdY24qHb/3Od48o+Co9eD3ejc42TmIkTLXZmgYHwtBWR8OyMdQDuEFY3DsqYaDl44Z2/vLgVbjatR0yQ7Z2wjqbJzSifdU=
Message-ID: <b4292e150802160141l5a9d36f5sbfeb3259678bffc0@mail.gmail.com>
Date: Sat, 16 Feb 2008 07:41:12 -0200
From: "Adolfo R. Brandes" <arbrandes@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: forcedeth: MAC-address reversed on resume from suspend
Cc: B.Steinbrink@gmx.de, bunk@kernel.org, andi@lisas.de, richie@coderworld.net,
       linux-kernel@vger.kernel.org, aabdulla@nvidia.com, jgarzik@pobox.com,
       netdev@vger.kernel.org
In-Reply-To: <20080107.232355.228915298.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080104034357.GA2113@atjola.homenet>
	 <b4292e150801061349v3b54ffc0vfed75dbcb83daf9b@mail.gmail.com>
	 <20080107014638.GA4170@atjola.homenet>
	 <20080107.232355.228915298.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 8, 2008 5:23 AM, David Miller <davem@davemloft.net> wrote:
> I am going to push this patch upstream, it is correct and we
> have a positive test case that failed before, so overall it's
> a net improvement even if we still don't exactly know why
> Adolfo's case still fails.

Sorry it took so long, but I got around to testing the patch properly,
i.e. same kernel on CK804 and MCP51, and it worked beautifully!
Thanks!

Adolfo
