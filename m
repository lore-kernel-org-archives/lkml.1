Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbZLCSDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbZLCSDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 13:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbZLCSDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 13:03:43 -0500
Received: from thsmsgxrt11p.thalesgroup.com ([192.54.144.134]:60431 "EHLO
	thsmsgxrt11p.thalesgroup.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753918AbZLCSDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 13:03:42 -0500
Message-ID: <4B17FD03.6070207@thalesgroup.com>
Date: Thu, 03 Dec 2009 19:01:39 +0100
From: =?ISO-8859-1?Q?Emmanuel_Fust=E9?= <emmanuel.fuste@thalesgroup.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC v2] Another approach to IR
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> On Thu, Dec 03, 2009 at 02:33:56PM -0200, Mauro Carvalho Chehab wrote:
> > Ferenc Wagner wrote:
> > > Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> > 
> > We should not forget that simple IR's don't have any key to select the address,
> > so the produced codes there will never have KEY_TV/KEY_DVD, etc.
>
> Wait, wait, KEY_TV, KEY_DVD, KEY_TAPE - they should be used to select
> media inputs in a device/application. My receiver accepts codees like
> that.
>   
Yes, it seem that there is confusion here.
Forget my proposition. It is a corner case that could be handled later 
if needed.


Cheers,
Emmanuel.
