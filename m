Return-Path: <linux-kernel-owner+w=401wt.eu-S1752695AbYLIFyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbYLIFyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 00:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbYLIFy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 00:54:28 -0500
Received: from rn-out-0910.google.com ([64.233.170.186]:18321 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbYLIFy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 00:54:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IEDeczDgd36m8RFxhhu9E5QyWvNf5td6VHne7SWHta/9jTmuY6PAuMFp6owkh0HG2N
         bQOWK8wvumf/ILw8sSxSQSYcW0NGqTma1awaDpcvCs1wF/R4jJw88eVFn150L6S/RBUS
         gnqOX05XV0w20yU05XG8x7euuYK7hTV0TJTG4=
Message-ID: <12bfabe40812082154y188e9167vd37589b758d9868d@mail.gmail.com>
Date: Tue, 9 Dec 2008 06:54:26 +0100
From: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
To: "Andi Kleen" <ak@linux.intel.com>
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
Cc: "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <493D0D42.2090203@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>
	 <12bfabe40812071355r65c13e52g5f3d94d3b060c939@mail.gmail.com>
	 <20081207141337.588aede5@infradead.org>
	 <12bfabe40812072248n3c931ce0hf030b3ac758026d4@mail.gmail.com>
	 <493CCFE4.2080802@jp.fujitsu.com>
	 <12bfabe40812080004p7438744eqeb884b42673bd73c@mail.gmail.com>
	 <493CEAA0.50201@jp.fujitsu.com> <493CEF38.3060004@linux.intel.com>
	 <493CF65B.30408@jp.fujitsu.com> <493D0D42.2090203@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2008 at 1:04 PM, Andi Kleen <ak@linux.intel.com> wrote:
> Also it might be really some problem with this particular CPU.
>
> -Andi
>
It might be interesting to notice that booting a different distro and
then doing a kexec from that into my 2.6.27.8 make the mce log
disappear.
