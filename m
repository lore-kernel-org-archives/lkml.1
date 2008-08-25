Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbYHYKxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbYHYKxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 06:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756974AbYHYKw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 06:52:59 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:60057 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272AbYHYKw4 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 06:52:56 -0400
Message-ID: <48B28F00.10202@de.ibm.com>
Date: Mon, 25 Aug 2008 12:52:48 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?UTF-8?B?Qk0gRGV1dHNjaGxhbmQgUmVzZWFyY2ggJiBEZXZlbG9wbWVudA==?=
 =?UTF-8?B?IEdtYkggLyBWb3JzaXR6ZW5kZXIgZGVzIEF1ZnNpY2h0c3JhdHM6IE1hcnRpbiA=?=
 =?UTF-8?B?SmV0dGVyLEdlc2Now6RmdHNmw7xocnVuZzogSGVyYmVydCBLaXJjaGVyLFNpdHo=?=
 =?UTF-8?B?IGRlciBHZXNlbGxzY2hhZnQ6IELDtmJsaW5nZW4gLyBSZWdpc3RlcmdlcmljaHQ=?=
 =?UTF-8?B?OiBBbXRzZ2VyaWNodCBTdHV0dGdhcnQsIEhSQiAyNDMyOTQ=?=
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: Jared Hulbert <jaredeh@gmail.com>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>, tim.bird@am.sony.com,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
References: <48AD00C4.6060302@gmail.com> <Pine.LNX.4.64.0808221650500.17105@vixen.sonytel.be> <6934efce0808220951i5a2cd6f9t70f9c522eae6f1d6@mail.gmail.com> <Pine.LNX.4.64.0808251136140.3893@vixen.sonytel.be>
In-Reply-To: <Pine.LNX.4.64.0808251136140.3893@vixen.sonytel.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> From your good relationship with the s390 developers, I had hoped you would
> have done some tests on s390 ;-)
Haha, we let you sort out the endianess issues first and then take the 
easy path :-). We have'nt tried it yet so far.
