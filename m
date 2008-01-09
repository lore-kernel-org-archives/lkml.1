Return-Path: <linux-kernel-owner+w=401wt.eu-S1759352AbYAIXkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbYAIXkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758643AbYAIXhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:37:54 -0500
Received: from nz-out-0506.google.com ([64.233.162.227]:54218 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364AbYAIXhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:37:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jhbGivZ8L9RNW509dasmMH3ST/wR37vUyLP6avId5tpN76EjllKViGPZZ1EEU+axAf6+QlODmmcHrrHc0sOivR6r5MbXLqm+eXIvV/G7z7x/IPZHfIIbFAZtiXgo6FF3PXzzeQTYilEbyX9TV4VsVVy4bBhFmiYJ/6d7nb/KHMY=
Message-ID: <4d8e3fd30801091537l440e396cu481093e74f0da479@mail.gmail.com>
Date: Thu, 10 Jan 2008 03:07:50 +0330
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: More breakage in native_rdtsc out of line in git-x86
Cc: "Harvey Harrison" <harvey.harrison@gmail.com>,
       "=?ISO-8859-1?Q?Bj=F6rn_Steinbrink?=" <B.Steinbrink@gmx.de>,
       "Ingo Molnar" <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080109224142.GB18480@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080109035534.GA30321@basil.nowhere.org>
	 <20080109141908.GB12855@one.firstfloor.org>
	 <20080109152208.GA21280@elte.hu>
	 <20080109155124.GB12923@one.firstfloor.org>
	 <20080109163017.GG17739@elte.hu>
	 <20080109174800.GA15346@one.firstfloor.org>
	 <20080109220948.GA2218@atjola.homenet>
	 <20080109222804.GF15612@one.firstfloor.org>
	 <1199918155.6424.71.camel@brick>
	 <20080109224142.GB18480@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/10/08, Andi Kleen <andi@firstfloor.org> wrote:

> I'm already cloning the branches; the problem is not getting conflicts etc.
> when updating.

Isn't git pull --force what you are looking for?

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
