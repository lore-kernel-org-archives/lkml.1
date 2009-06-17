Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbZFQV0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbZFQV0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 17:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbZFQV0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 17:26:13 -0400
Received: from mail-qy0-f201.google.com ([209.85.221.201]:33852 "EHLO
	mail-qy0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbZFQV0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 17:26:12 -0400
MIME-Version: 1.0
In-Reply-To: <4A391A54.7000109@goop.org>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
	 <4A380494.6030506@goop.org> <1245249469.5982.251.camel@desktop>
	 <4A390B9A.40806@goop.org> <1245254936.5982.261.camel@desktop>
	 <4A391A54.7000109@goop.org>
Date: Wed, 17 Jun 2009 14:26:14 -0700
Message-ID: <d6200be20906171426n71979124i4b359b6f4fc35d7e@mail.gmail.com>
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny && usage
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Daniel Walker <dwalker@fifo99.com>, Greg Kroah-Hartman <greg@kroah.com>,
       Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 9:31 AM, Jeremy Fitzhardinge<jeremy@goop.org> wrote:
> On 06/17/09 09:08, Daniel Walker wrote:
...
> Also, what its usermode ABI is, how stable it is, whether its generally
> useful, does it have glibc/other library support, etc.  Would you ever want
> to use this in a non-Android context?

You could use this in a non-android context, but the abi is not
stable. There is some documentaion of the current user space api at
http://developer.android.com/reference/android/os/IBinder.html. You
can also find more information at http://www.open-binder.org/ which is
where the api came from.

-- 
Arve Hjønnevåg
