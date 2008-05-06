Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbYEFO2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbYEFO2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 10:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbYEFO2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 10:28:23 -0400
Received: from ag-out-0708.google.com ([72.14.246.241]:17748 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbYEFO2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 10:28:22 -0400
Message-ID: <fa686aa40805060728x2cb680e3y7338bacaa400ed1a@mail.gmail.com>
Date: Tue, 6 May 2008 08:28:20 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH 24/56] microblaze_v2: time support
Cc: monstr@seznam.cz, "John Williams" <john.williams@petalogix.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au
In-Reply-To: <200805061338.24870.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
	 <1210033811.5798.188.camel@localhost> <48202C9E.7070800@seznam.cz>
	 <200805061338.24870.arnd@arndb.de>
X-Google-Sender-Auth: 2638364207d9af24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2008 at 5:38 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 06 May 2008, Michal Simek wrote:
>  > I saw a lot of comments about files but I have never seen any comments that
>  > any file is OK.
>  > Does it mean everything is broken??? I don't think so.
>
<snip>
>
>  I think you're doing a great job on this. Any patch set of this size that
>  has been maintained for a long time outside of the kernel goes through this
>  phase where everyone tells you what to improve, based on their experience,
>  while everything you do right about the patches is just taken for granted.
>
>  Don't let yourself get discouraged by the negative comments, we're really
>  all just trying to help you do the right thing!

Let me add my voice to Arnd's.  This is a *big* task and you're
handling it very well.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
