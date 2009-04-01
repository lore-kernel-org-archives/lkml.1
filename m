Return-Path: <linux-kernel-owner+w=401wt.eu-S1759492AbZDAGmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492AbZDAGmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 02:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757828AbZDAGm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 02:42:27 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:21336 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751009AbZDAGm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 02:42:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NAIeFIicrv4wD+Z5SuNWr9o45E1lEqDASFUkvjYJvRH5lKPguUer82eiDMVe/0nWGmtQSwE2HYoX/B7qx3HE214rzXorOGJMZuYKyN0neh4wolmm4p5iJYWwkUqU3npeI1NHSz68HLxdvldAXmuVQJcEYHRQiMxijPyOLWhnB70=  ;
X-YMail-OSG: qJCRGPAVM1nrU6dxek4eSoLxndy0DDCpepx9gcUHxOXCqcsUnoD_NVzvfLRl3HR7nxXulZo6Yzk.V_rGn_.kAq0pyccrSHw22tjCfr7gYAolntlvUEBWqPKgqZ7RFDcdFEawsQRTorGaxGjpLT6w8Aen2j2WzB4TWb5CBuBpM8I5bKy45PcFLe9iDAEc1oR6ddK4AA2OwCkIYXMM3vg2I3ND1lELYfgPHCT3mDbFCaboK8iHVX4UEmJAdjxrGgpEYnMHaMWtfyCdHAu1RsJi0D5BojPmjIcJeuiYeAQM_Xpy5xCGVyy3r.hOlYV1z1dufIqSfKBXAYlThGNmjkiX5tEPPmo-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: dedekind@infradead.org
Subject: Re: [patch/rfc 2.6.29 2/2] MTD: support driver model updates
Date: Tue, 31 Mar 2009 23:42:23 -0700
User-Agent: KMail/1.9.10
Cc: Linux MTD <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
References: <200903260039.34013.david-b@pacbell.net> <200903312257.37434.david-b@pacbell.net> <1238566203.20906.31.camel@localhost.localdomain>
In-Reply-To: <1238566203.20906.31.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903312342.24019.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 March 2009, Artem Bityutskiy wrote:
> OK. MTD long needs sysfs, and I'm very happy with this
> patches, even though they are not 100% complete. Good
> start anyway.
> 
> Acked-by: Artem Bityutskiy <dedekind@infradead.org>

Thanks.  I'll expect someone to handle getting these
merged through the MTD tree, then.

And I'll be rather surprised if no more attributes
appear by the time this gets to mainline!  :)

- Dave


