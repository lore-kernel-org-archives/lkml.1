Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbZAETTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbZAETTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbZAETTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:19:25 -0500
Received: from outbound-mail-124.bluehost.com ([67.222.38.24]:50757 "HELO
	outbound-mail-124.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755058AbZAETTY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:19:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=CRYWtcNgIGDHozQy3Hr2GzQcGtV9rlOoqVvMo/9+l1HaRUY8yDdeXijwEpEZJLuxsBmrDv3hLbvMy/aH1gYEmer8ez7ocONY+YW8pXB803oMgeqOdRY4H0DhZAbF7r24;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] pci-quirks: HP hides SMBus controller in Compaq nx9500 laptops
Date: Mon, 5 Jan 2009 11:19:20 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.9-73.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: "Micha? Miros?aw" <mirq-linux@rere.qmqm.pl>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <20081223215407.GB32525@rere.qmqm.pl> <19700101064603.GA1406@ucw.cz>
In-Reply-To: <19700101064603.GA1406@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901051119.20684.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 31, 1969 10:46 pm Pavel Machek wrote:
> On Tue 2008-12-23 22:54:07, Micha? Miros?aw wrote:
> > I found no references to SMBus in ACPI DSDT disassembly on my laptop
> > so this should be safe.
> >
> > Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
>
> Well, it could still be used by smm bios traps...

Also, the changelog doesn't include a description of what this patch fixes, if 
anything.  Care to resend with an explanation Michal?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center

