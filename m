Return-Path: <linux-kernel-owner+w=401wt.eu-S966146AbXILAD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966146AbXILAD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 20:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755614AbXILADt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 20:03:49 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:42820 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbXILADs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 20:03:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B9y2PdwyjpYiyktCWtyZHlOpkboUw/ArTHGkY9Bx56tfuBxmBnBCzh2EXLb6NbJr4qZ2VUq7mraZ90xkFT3HFO8Tez02OI2AC3ZWBgAfXti2/8W2b/Sx9duBIBsGvDUCxdxPL9r8Bmdpk1AZtniNbkf9vy/atjsrUh+Z0qx4J+M=
Message-ID: <8b67d60709111703v6c156d9brbc821363594c878f@mail.gmail.com>
Date: Wed, 12 Sep 2007 01:03:47 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: "=?ISO-8859-1?Q?Bj=F6rn_Steinbrink?=" <B.Steinbrink@gmx.de>
Subject: Re: time_after - what on earth???
Cc: "Rene Herman" <rene.herman@gmail.com>, linux-kernel@vger.kernel.org,
       linuxsh-dev@lists.sourceforge.net, "Paul Mundt" <lethal@linux-sh.org>
In-Reply-To: <20070911235057.GA7348@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <8b67d60709111505u61771a1do74c82a55430ec214@mail.gmail.com>
	 <46E7128D.1080006@gmail.com>
	 <8b67d60709111515m5b45c57emef5cc2f74795ed7a@mail.gmail.com>
	 <46E7145D.10907@gmail.com> <20070911230940.GA7070@atjola.homenet>
	 <8b67d60709111610s41e1964dsc2fe21a6eca4096@mail.gmail.com>
	 <20070911235057.GA7348@atjola.homenet>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2007, Björn Steinbrink <B.Steinbrink@gmx.de> wrote:

>
> A fix would likely initialize "when" to jiffies.
>
> Björn
>

Thanks, I'll try that :)
