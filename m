Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbZFKRlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbZFKRlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 13:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbZFKRl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 13:41:29 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:10601 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbZFKRl2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 13:41:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ImUCRN46S/hECcazn4L4iHPynGWgHF0YxmQzPft17oefcfstIflbBOEyv0CmXc2Xj2
         tbCy22tK5rVidwl4FHip1JpWZtX4Aa7B4NS+zETDEpy57Qk0FVWfEALcRYBUErtINms4
         YdRI0bRktMSYZsMVzbL5nsDGqB45sJmTuRnrg=
MIME-Version: 1.0
In-Reply-To: <20090611152502.GG19203@electro-mechanical.com>
References: <20090609195100.GY19203@electro-mechanical.com>
	 <b6c5339f0906091339j3784c36bxe888af16272fbcde@mail.gmail.com>
	 <20090610112357.GB19203@electro-mechanical.com>
	 <20090610113406.GE19635@hash.localnet>
	 <20090610115432.GC19203@electro-mechanical.com>
	 <20090610120736.GF19635@hash.localnet>
	 <20090611152502.GG19203@electro-mechanical.com>
Date: Thu, 11 Jun 2009 13:41:30 -0400
X-Google-Sender-Auth: 4d772f90088803cf
Message-ID: <b6c5339f0906111041u2cc55324w7b5c2523abbe2def@mail.gmail.com>
Subject: Re: 3com 3crxjk10075 with ath5k driver
From: Bob Copeland <me@bobcopeland.com>
To: William Thompson <wt@electro-mechanical.com>
Cc: linux-kernel@vger.kernel.org, ath5k-devel <ath5k-devel@venema.h4ckr.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 11:25 AM, William
Thompson<wt@electro-mechanical.com> wrote:
> On Wed, Jun 10, 2009 at 08:07:36AM -0400, Bob Copeland wrote:
>> $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
>>
>
> That's huge!  Isn't there an easier way to do it?

Unfortunately, it depends on surrounding rfkill framework that hit the tree
after 2.6.30.  Now that compat-wireless builds, you can try it, but since it
is a backport, YMMV.

-- 
Bob Copeland %% www.bobcopeland.com
