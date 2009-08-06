Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbZHFNLC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbZHFNLC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 09:11:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbZHFNK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 09:10:59 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:45772 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbZHFNK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 09:10:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JJXHFmBhlJ9bsMzmkduVkwJOSG9sw/wcir9l5FSyR22pDm8UOxYQkr8UwA6W6ytjRn
         1+PCVcxCh1HEAntBkvi/dBOVs63DempSa6SMFKDAZh3fcBCkLAVN8OkCKIaLP7qx6w/r
         pyqm9rnr1Pv4gZGg+d5DEZe77lVQ6jJFZ//BQ=
MIME-Version: 1.0
In-Reply-To: <200908061416.08564.rjw@sisk.pl>
References: <20090803163304.GF5002@laptop> <200908052330.08452.rjw@sisk.pl>
	 <20090806085144.GS13236@buzzloop.caiaq.de>
	 <200908061416.08564.rjw@sisk.pl>
Date: Thu, 6 Aug 2009 22:10:57 +0900
Message-ID: <aec7e5c30908060610l7edab1c1oae08720a675937a9@mail.gmail.com>
Subject: Re: [PATCH] PM: Add convenience macro to make switching to dev_pm_ops 
	less error-prone
From: Magnus Damm <magnus.damm@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Daniel Mack <daniel@caiaq.de>, Frans Pop <elendil@planet.nl>,
       pHilipp Zabel <philipp.zabel@gmail.com>,
       albin.tonnerre@free-electrons.com, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 6, 2009 at 9:16 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> On Thursday 06 August 2009, Daniel Mack wrote:
>> When is a good point to resend patches that use this macro? I guess they
>> won't make it to .31 anyway, right? So I just wait for the next merge
>> window?
>
> Yes, I think that would be the right thing to do.

Is it a good idea to disable the warning before the final 2.6.31 release?

Cheers,

/ magnus
