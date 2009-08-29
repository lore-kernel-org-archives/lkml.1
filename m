Return-Path: <linux-kernel-owner+w=401wt.eu-S1752766AbZH2Xaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbZH2Xaj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 19:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbZH2Xaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 19:30:39 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:44816 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbZH2Xai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 19:30:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GzF9xPfxHBk9nN/OTuy1eCYg4rBxcW+d3g8TXc0EDKQmZy6yvZH1Lxlh/n7fwP34S7
         VvQnsTzznYX0qnvI1EhElBmE5qTm41KlKVPQkK8c5YXOmRQcHbwgcIVAbdZPy1Twe25g
         AMr0kDeAQuEmNQRBzpd96Ci5jaDmpJVPfjOBQ=
Subject: Re: Is acpi_ec_ecdt_probe() broken? (was: Re: ACPI locks hardware
 devices when it doesn't detect vista)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mario <rety@poczta.onet.pl>, Len Brown <lenb@kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
In-Reply-To: <200908300037.45412.rjw@sisk.pl>
References: <1250945310.14167.150.camel@maxim-laptop>
	 <1251575484.10321.11.camel@maxim-laptop>
	 <200908292305.55050.rety@poczta.onet.pl>  <200908300037.45412.rjw@sisk.pl>
Content-Type: text/plain
Date: Sun, 30 Aug 2009 02:30:34 +0300
Message-Id: <1251588634.15582.0.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-30 at 00:37 +0200, Rafael J. Wysocki wrote:
> On Saturday 29 August 2009, Mario wrote:
> > Exact model is Compal JFL92.
> > I've attached a dmidecode output.
> 
> OK
> 
> Maxim, Mario, can you create a bug entry in the kernel Bugzilla for this
> issue and put my address into the CC list in there?

Done,

http://bugzilla.kernel.org/show_bug.cgi?id=14086


Best regards,
	Maxim Levitsky

