Return-Path: <linux-kernel-owner+w=401wt.eu-S1758567AbZFXNyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567AbZFXNyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 09:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbZFXNx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 09:53:59 -0400
Received: from fifo99.com ([67.223.236.141]:40760 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbZFXNx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 09:53:58 -0400
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny &&
	usage
From: Daniel Walker <dwalker@fifo99.com>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: Brian Swetland <swetland@google.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
       hackbod@android.com
In-Reply-To: <d6200be20906191713n161d4281u1f43804e675e29ac@mail.gmail.com>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
	 <4A380494.6030506@goop.org> <1245249469.5982.251.camel@desktop>
	 <4A390B9A.40806@goop.org> <1245254936.5982.261.camel@desktop>
	 <4A391A54.7000109@goop.org>
	 <d6200be20906171426n71979124i4b359b6f4fc35d7e@mail.gmail.com>
	 <1245274308.5982.268.camel@desktop>
	 <a55d774e0906191220i7280fe77qb724037fb92fab86@mail.gmail.com>
	 <1245451983.32124.25.camel@desktop>
	 <d6200be20906191713n161d4281u1f43804e675e29ac@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 24 Jun 2009 06:13:43 -0700
Message-Id: <1245849223.32124.112.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-19 at 17:13 -0700, Arve Hjønnevåg wrote:
> 
> These are mostly questions for the framework team. The binder driver
> is there to support our user space code. At some point we used the
> driver from www.open-binder.org, but we ran into, and fixed, a lot of
> bugs (especially when processes died), so we determined it would be
> faster to rewrite the driver from scratch.
> 

Is there someone in your framework team that would be willing to respond
to these questions ? (I know you added hackbod to the CC, but they
aren't responding..)

Daniel

