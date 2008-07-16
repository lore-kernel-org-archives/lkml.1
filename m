Return-Path: <linux-kernel-owner+w=401wt.eu-S1759967AbYGPXdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967AbYGPXdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 19:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbYGPXdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 19:33:10 -0400
Received: from outbound-mail-35.bluehost.com ([69.89.18.155]:47097 "HELO
	outbound-mail-35.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752959AbYGPXdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 19:33:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User:DomainKey-Status;
	b=D/F6mAG5AYg8SOQ1cP2GR3cr5wqj59/sTUQrV4/hvymUnJT46B2PbmvCJK3f25nze239OcyDXDBUCXhWQSlgjsm0DRG7eZlwVXiGlHomxybDA90e4J3zU4chi7ZJkxGt;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Please pull ACPI updates
Date: Wed, 16 Jul 2008 16:33:01 -0700
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20080716214516.GA10777@basil.nowhere.org> <200807170011.12184.rjw@sisk.pl>
In-Reply-To: <200807170011.12184.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807161633.01375.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 16, 2008 3:11 pm Rafael J. Wysocki wrote:
> On Wednesday, 16 of July 2008, Andi Kleen wrote:
> > Linus,
> >
> > Please pull from
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-acpi-merge-2.6
> > release-2.6.27
> >
> > to get the initial ACPI updates for 2.6.27. We got a few more changes
> > dependent on yet unpulled trees and some other candidate patches,
> > but that's the bulk for the changes intended for 2.6.27. Most of that
> > has been collected by Len Brown before he went on sabbatical. I was
> > relatively conservative with additional changes so far.
>
> Well, IMO it would be better to merge PCI first.

Yeah, they're interdependent (I pulled from Len's tree, hopefully Andi 
preserved the changesets).  I had wanted to do a little more testing of what 
I've got, but I haven't heard any huge complaints so far so maybe things are 
ok.  I'll generate a pull request now.

Jesse
