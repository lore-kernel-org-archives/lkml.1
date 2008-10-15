Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbYJOKtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbYJOKtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 06:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbYJOKtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 06:49:24 -0400
Received: from outbound-mail-40.bluehost.com ([69.89.20.194]:46751 "HELO
	outbound-mail-40.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751706AbYJOKtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 06:49:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=CDefgmTcobNFdI9f/C6sraxs2Q3Z4rfOkTwgZU+iskuxbttclnGklTa93e432SVBOdjZ7LTwav2X1EtPszjsLzRDIjqGyIalWKTuquMlvhz3vn0KBY3EytNTNdTm7VvN;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Vincent Legoll" <vincent.legoll@gmail.com>
Subject: Re: [PATCH] PCI probing debug message uniformization
Date: Wed, 15 Oct 2008 03:49:08 -0700
User-Agent: KMail/1.9.10
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <4727185d0809291403w38422338p3ffe2a1c27c39939@mail.gmail.com> <200810100907.35798.jbarnes@virtuousgeek.org> <4727185d0810120326k482a824ds7f8dbd6a4cd431f3@mail.gmail.com>
In-Reply-To: <4727185d0810120326k482a824ds7f8dbd6a4cd431f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810150349.08882.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 90.152.48.188 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, October 12, 2008 3:26 am Vincent Legoll wrote:
> On Fri, Oct 10, 2008 at 6:07 PM, Jesse Barnes <jbarnes@virtuousgeek.org> 
wrote:
> >> So here is the new version cut'n'pasted from git-format-patch
> >
> > Can you respin against linux-next and send me a fresh copy?  This one
> > seems to have been corrupted somehow (sorry for the slow reply, it's been
> > sitting in my 'to apply' mbox for awhile now).
>
> Here it is, attached, rebased on top of -next

Applied, thanks.

Jesse
