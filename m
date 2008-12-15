Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbYLOU7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbYLOU7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 15:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755794AbYLOU7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 15:59:13 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:19557 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbYLOU7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 15:59:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rL8tmjw0mfWCu0u5PgSSP3b8JhVu57Zp6gXDFOuFmeeFUCIBjRC0Ib82HI6/tk0tyN
         c8ixt7K+cp94wSWOOnPJAK1k/Y386EQuAFIsGoaysUWDizYDOtGlT38xFiL1hJQWM75L
         au5ubf+4jL+jDtJT4zVIXw7t1cTMSNKdBeSBo=
Message-ID: <12bfabe40812151259n7394a9ccp30a8579b08fedbd2@mail.gmail.com>
Date: Mon, 15 Dec 2008 21:59:10 +0100
From: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
To: "Andi Kleen" <ak@linux.intel.com>
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
Cc: "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <871vwheg9o.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>
	 <12bfabe40812072248n3c931ce0hf030b3ac758026d4@mail.gmail.com>
	 <493CCFE4.2080802@jp.fujitsu.com>
	 <12bfabe40812080004p7438744eqeb884b42673bd73c@mail.gmail.com>
	 <493CEAA0.50201@jp.fujitsu.com> <493CEF38.3060004@linux.intel.com>
	 <493CF65B.30408@jp.fujitsu.com> <493D0D42.2090203@linux.intel.com>
	 <12bfabe40812082154y188e9167vd37589b758d9868d@mail.gmail.com>
	 <871vwheg9o.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
a little update about this. It was actually a bios problem. A bios
update(beta) finally solved it.

Giangiacomo
