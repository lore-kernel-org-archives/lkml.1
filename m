Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbYJXTWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbYJXTWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 15:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbYJXTWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 15:22:43 -0400
Received: from outbound-mail-03.bluehost.com ([69.89.21.13]:38363 "HELO
	outbound-mail-03.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750979AbYJXTWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 15:22:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=sYjatwb35qPq4z5EmzoPkhThQvWUYSg8YQNWdzBmfw6B6KNcI4DSBjdC4DpabDsuxxhPwq4Rs5C62kINQRS6OEGOyjvFQN+KQS+WMDdOefR7TTDQ2ZGGBjLbY5iRSt2D;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Oops in ACPI with git latest
Date: Fri, 24 Oct 2008 12:22:32 -0700
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: "Moore, Robert" <robert.moore@intel.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <1224791103.3330.37.camel@localhost.localdomain> <200810241104.19704.jbarnes@virtuousgeek.org> <200810242043.04078.rjw@sisk.pl>
In-Reply-To: <200810242043.04078.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810241222.32979.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 24, 2008 11:43 am Rafael J. Wysocki wrote:
> On Friday, 24 of October 2008, Jesse Barnes wrote:
> > So who wants to send me a final patch for this?
>
> I already did: http://marc.info/?l=linux-kernel&m=122484871717023&w=4
> but I can remove the "!output.pointer || " if you prefer. :-)

Yeah Bob said it would likely contain garbage anyway, so we should just remove 
it.

Jesse
