Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbZLAP6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbZLAP6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 10:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZLAP6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 10:58:43 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:39120 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbZLAP6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 10:58:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=L361mgLCDPyX+GtTkPNmbvWrPHys31wS20736Ev10PqSXPkb5lJu4PWVUJtInFAirM
         O120Eq74RJIuvNJ07k5LS0wAI73WsMoA3oCnlByF2lw29sEcQJNXDBZ14F86i+bJI/aR
         DHiRKYMa4XJgJj86wF/CQDD3WBdtEzX0ECBac=
MIME-Version: 1.0
In-Reply-To: <20091201123130.GA23323@infradead.org>
References: <4AE8D005.1030302@twiddle.net>
	 <1256956383-2652-1-git-send-email-mcree@orcon.net.nz>
	 <b4198de60911302006u43f52bd5xe198615971352696@mail.gmail.com>
	 <20091201123130.GA23323@infradead.org>
Date: Tue, 1 Dec 2009 10:58:47 -0500
Message-ID: <b4198de60912010758k35028979l58edca699d2b20b0@mail.gmail.com>
Subject: Re: [PATCH] Alpha: Rearrange thread info flags fixing two regressions
From: Matt Turner <mattst88@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Michael Cree <mcree@orcon.net.nz>, Richard Henderson <rth@twiddle.net>,
       linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
       ink@jurassic.park.msu.ru, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 1, 2009 at 7:31 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Nov 30, 2009 at 11:06:52PM -0500, Matt Turner wrote:
>> Applied to alpha-2.6.git. Thanks!
>
> Can you push this to Linus ASAP so that 2.6.33 will work nicely out of
> the box on alpha?

It's in mainline now. Linus just pulled my tree. :)

Matt
