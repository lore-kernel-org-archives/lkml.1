Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbYIAR1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbYIAR1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 13:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbYIAR1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 13:27:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:41555 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbYIAR1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 13:27:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rZq56OG0Uar55daV88fLeJISONAzZj4fOUvwGv/bqAQ1ap3GDA1epjn99Zk4u2fHL8
         0bL3spX68zFwYiX64Vu+R/PwAcTWdTHhpEkoj/9EmPgdtVGCZ97b6rFxgz+2JormIvlw
         M0toUNHGIGSwYo7qR4DGN3eBl1fAaHT2T8QgM=
Message-ID: <3f9a31f40809011027o34dbfccfh9ed82228938cb572@mail.gmail.com>
Date: Mon, 1 Sep 2008 13:27:08 -0400
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [Bug #11271] BUG: fealnx in 2.6.27-rc1
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Francois Romieu" <romieu@fr.zoreil.com>
In-Reply-To: <20080901100649.59c1ab1f@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
	 <N8SeMoDzuxC.A.xIG.OkbuIB@albercik>
	 <3f9a31f40809011002k572450ffg90654912f3e1fa2a@mail.gmail.com>
	 <20080901100649.59c1ab1f@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arjan,

On Mon, Sep 1, 2008 at 1:06 PM, Arjan van de Ven <arjan@infradead.org> wrote:
>>
>> Still exists in 2.6.27-rc5 :
>>
>> NETDEV WATCHDOG: eth0 (fealnx): transmit timed out
>
>
> did you ever get transmit timeouts before 2.6.27 ?
> (I would suspect you did)
>

may be you are right, I have never noticed it earlier. But currently
this is soo serious that it has totally screwed up my networking when
I use fealnx based NICs.

Thank you,

Jaswinder Singh.
