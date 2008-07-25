Return-Path: <linux-kernel-owner+w=401wt.eu-S1752660AbYGYQOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbYGYQOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 12:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbYGYQOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 12:14:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43343 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbYGYQOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 12:14:39 -0400
Message-ID: <4889FBE4.9070100@zytor.com>
Date: Fri, 25 Jul 2008 12:14:28 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Filipe Brandenburger <filipe.brandenburger@idilia.com>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: Recommendation on an eSATA card well supported by Linux with
 built-in drivers and that supports hot plug
References: <fa.jn2UBng193xTV9fhfIdhKpQQKRo@ifi.uio.no>	<4888E188.4050708@shaw.ca>	<488900E2.4000208@zytor.com>	<4889F28B.6000307@idilia.com> <20080725165255.43595c74@lxorguk.ukuu.org.uk>
In-Reply-To: <20080725165255.43595c74@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Would you be also so kind as to recommend an actual eSATA card that uses
>> the JMicron chip? Preferrably one that you have and use on a daily basis.
> 
> I've found the same in the UK - but there are alternatives although not
> AHCI. The latest kernel supports the INIC SATA cards which lack some of
> the goodies but do seem to be common on eSATA cards.

I'm using the SYBA SD-SA2PEX-1E.

	-hpa
