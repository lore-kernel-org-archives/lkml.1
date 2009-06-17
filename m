Return-Path: <linux-kernel-owner+w=401wt.eu-S1761340AbZFQVjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761340AbZFQVjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 17:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbZFQVi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 17:38:58 -0400
Received: from claw.goop.org ([74.207.240.146]:35410 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208AbZFQVi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 17:38:57 -0400
Message-ID: <4A396273.2020207@goop.org>
Date: Wed, 17 Jun 2009 14:38:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
CC: Daniel Walker <dwalker@fifo99.com>, Greg Kroah-Hartman <greg@kroah.com>,
       Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny && usage
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>	 <4A380494.6030506@goop.org> <1245249469.5982.251.camel@desktop>	 <4A390B9A.40806@goop.org> <1245254936.5982.261.camel@desktop>	 <4A391A54.7000109@goop.org> <d6200be20906171426n71979124i4b359b6f4fc35d7e@mail.gmail.com>
In-Reply-To: <d6200be20906171426n71979124i4b359b6f4fc35d7e@mail.gmail.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/09 14:26, Arve Hjønnevåg wrote:
> You could use this in a non-android context, but the abi is not
> stable. There is some documentaion of the current user space api at
> http://developer.android.com/reference/android/os/IBinder.html. You
> can also find more information at http://www.open-binder.org/ which is
> where the api came from.
>   

So the ancestry is Be -> Palm -> Android/Google -> Linux?

    J
