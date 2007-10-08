Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbXJHXmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbXJHXmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 19:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbXJHXmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 19:42:37 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:38024 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbXJHXmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 19:42:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding:sender;
        b=C9rVpugmVJUbEYpZD6VJXRHSWK0h+KpAwa3otXGlj/nJtD/2QkJVaAVWa/CLxD87yBqiR3g7pXx04i90Mn4Cyx2MG7Pi6oECvaLJMgUu0FojR5W2CX8A4b6Tdq39bGmiAoViTeA9RxgcimTy5LbiYakeY9McDovzuOJ9K66Axek=
Subject: Re: parallel networking
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, peter.p.waskiewicz.jr@intel.com, krkumar2@in.ibm.com,
       johnpol@2ka.mipt.ru, herbert@gondor.apana.org.au, kaber@trash.net,
       shemminger@linux-foundation.org, jagana@us.ibm.com,
       Robert.Olsson@data.slu.se, rick.jones2@hp.com, xma@us.ibm.com,
       gaagaan@gmail.com, netdev@vger.kernel.org, rdreier@cisco.com,
       mingo@elte.hu, mchan@broadcom.com, general@lists.openfabrics.org,
       kumarkr@linux.ibm.com, tgraf@suug.ch, randy.dunlap@oracle.com,
       sri@us.ibm.com, linux-kernel@vger.kernel.org
In-Reply-To: <20071008.153353.58431888.davem@davemloft.net>
References: <470A3D24.3050803@garzik.org>
	 <20071008.141154.107706003.davem@davemloft.net>
	 <1191882618.4373.99.camel@localhost>
	 <20071008.153353.58431888.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 08 Oct 2007 19:42:25 -0400
Message-Id: <1191886945.4373.141.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-10 at 15:33 -0700, David Miller wrote:

> Multiply whatever effect you think you might be able to measure due to
> that on your 2 or 4 way system, and multiple it up to 64 cpus or so
> for machines I am using.  This is where machines are going, and is
> going to become the norm.

Yes, i keep forgetting that ;-> I need to train my brain to remember
that.

cheers,
jamal



