Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbYJ1KJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbYJ1KJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 06:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbYJ1KJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 06:09:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:48828 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbYJ1KJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 06:09:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=BwoDBHP68OGuu66cGhsrX0WDOA5dKf7ut1Q+LT1gM3nm8zuJPKKRwWXQ0V+jms3F1B
         NG+SFY7Iz4R9IojrqnS6ZlpE1vfJi3jY+aLke9U7ETjhevwFpZoKHiT+4GC2jpxP7OW4
         Co6p05RJPawo9JH2zIwxnhYqGaSMMW9lb6fcU=
Message-ID: <4906E4BE.9050304@gmail.com>
Date: Tue, 28 Oct 2008 11:09:02 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, Edward Hsu <edward_hsu@realtek.com.tw>,
       Ivan Vecera <ivecera@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: r8169 MAC addresses broken
References: <490380C8.6070003@simon.arlott.org.uk> <4903947A.3060206@gmail.com> <20081025223443.GA30913@electric-eye.fr.zoreil.com> <4904A7C5.7090801@gmail.com> <20081026174654.GB24790@electric-eye.fr.zoreil.com>
In-Reply-To: <20081026174654.GB24790@electric-eye.fr.zoreil.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2008 06:46 PM, Francois Romieu wrote:
> Jiri Slaby <jirislaby@gmail.com> :
> [...]
>> Hmm, no. How can one restore eeprom contents without making a brick from the
>> notebook? I seem to have all zeroes in the eeprom mac address area.
> 
> :o(
> 
> Same thing if you unplug the battery ?

Thanks, now it seems to be OK.
