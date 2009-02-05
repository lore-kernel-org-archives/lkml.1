Return-Path: <linux-kernel-owner+w=401wt.eu-S1759145AbZBEQ2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145AbZBEQ2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 11:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZBEQ22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 11:28:28 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:62334 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbZBEQ21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 11:28:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iW1yR9CCztTdTKQPkCqIO38iEWe0Q7NSq3TuCJP0g+mLcAJaNDGSGlORBxt1mNq5Wv
         7ghpcGqbz97rIRmf4/2dg+lohDllDWJsPmhQiIxudX4a/R453iB1+E3TNbDgEn9eYbSc
         4dxqhxBSF854caBHXRtJxgBCxV0eDGyOJSF3g=
MIME-Version: 1.0
In-Reply-To: <20090205155854.GG6915@linux.vnet.ibm.com>
References: <20090130200757.GA14999@Krystal>
	 <20090205140432.GE6915@linux.vnet.ibm.com>
	 <20090205150242.GA27895@Krystal>
	 <20090205151841.GF6915@linux.vnet.ibm.com>
	 <20090205153825.GA30255@Krystal>
	 <20090205155854.GG6915@linux.vnet.ibm.com>
Date: Thu, 5 Feb 2009 21:58:25 +0530
Message-ID: <5d5443650902050828h75738f0bg48ab16e20ed802a4@mail.gmail.com>
Subject: Re: [ltt-dev] LTTng 0.89 for Linux 2.6.29-rc3
From: Trilok Soni <soni.trilok@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       ltt-dev@lists.casi.polymtl.ca,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Thu, Feb 5, 2009 at 9:28 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>>
>> Are you using quilt to apply the patchset series file in the right order ?
>
> Ummm...  No.  I never have used quilt.
>
> Ah, there is a series file.  I guess it would not be too hard to make
> an appropriate "sh" command:
>

How about trying?


#quilt push -a

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
