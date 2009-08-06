Return-Path: <linux-kernel-owner+w=401wt.eu-S1752529AbZHFHIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbZHFHIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 03:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbZHFHIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 03:08:46 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:39129 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbZHFHIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 03:08:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hqDRC+WGW9hu4DCNmJdu3Y/0hw9SLD73h9m75XYclc3PD2NdoqKAGI2WJoNuyl9Yqy
         4BEL3YafIH5b7GfjbfYZolXlpujjRRMB5oRyfivuFhGoONQIn39bsMTyahenRnvcwXyt
         ZKf3KxA8w1pdekmai80cMVKwv5RybQ6HBMxHU=
MIME-Version: 1.0
In-Reply-To: <20090805185334.GA4535@Pilar.aei.mpg.de>
References: <1249409546-6343-1-git-send-email-mel@csn.ul.ie>
	 <1249409546-6343-5-git-send-email-mel@csn.ul.ie>
	 <20090804112246.4e6d0ab1.akpm@linux-foundation.org>
	 <20090804195717.GA5998@elte.hu>
	 <16246.1249484030@turing-police.cc.vt.edu>
	 <20090805185334.GA4535@Pilar.aei.mpg.de>
Date: Thu, 6 Aug 2009 10:08:44 +0300
X-Google-Sender-Auth: 9090423dd49466c9
Message-ID: <84144f020908060008x34a320e2nc6a6bf8a665e51b4@mail.gmail.com>
Subject: Re: perf: "Longum est iter per praecepta, breve et efficax per 
	exempla"
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Valdis.Kletnieks@vt.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Carlos,

On Wed, Aug 5, 2009 at 9:53 PM, Carlos R. Mafra<crmafra2@gmail.com> wrote:
> A few examples of how 'perf' can be used, from an e-mail by
> Ingo Molnar http://lkml.org/lkml/2009/8/4/346.
>
> Signed-off-by: Carlos R. Mafra <crmafra2@gmail.com>
> ---
>
> This "patch" is my way of _suggesting_ some "documentation by examples"
> of what 'perf' can do to the guys who can really write it :-)

I was also looking for a perf "cookbook" and Ingo suggested we should
put this stuff on the kernel.org wiki:

http://perf.wiki.kernel.org/index.php/Main_Page

How about just putting the email there?

                        Pekka
