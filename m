Return-Path: <linux-kernel-owner+w=401wt.eu-S932908AbXC0Ee1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908AbXC0Ee1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 00:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932873AbXC0Ee1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 00:34:27 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:54754 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396AbXC0Ee0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 00:34:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eZx+jsTeK3MKBvohWr/NIGBU+jU5GeAgVtQoUqiLeY+uOh6XXKmdSmyOYRhcXUF7htidkt/1zPTfJgVg+ef3P+dvXtNXH4Y6HYjS6mkN9xUvmv6sCU35ZzEJq0S3FaQ+RLawJALCp74N3GeZmM23dwerUVMxiW32osaxyADnQB0=
Message-ID: <8bd0f97a0703262134h20bdf8dcqb1043ca176a7149c@mail.gmail.com>
Date: Tue, 27 Mar 2007 00:34:25 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>, "Wu, Bryan" <bryan.wu@analog.com>,
       "Arnd Bergmann" <arnd@arndb.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Blackfin arch: add kdebug header file
In-Reply-To: <20070327035734.GA25883@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1174903941.32691.72.camel@roc-desktop>
	 <200703262345.09489.arnd@arndb.de>
	 <1174966837.6966.13.camel@roc-desktop>
	 <20070327035734.GA25883@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/26/07, Paul Mundt <lethal@linux-sh.org> wrote:
> You should really consider the latter for getting updates merged in the future

we're planning for this, but the short term it isnt doable for us

> now that most of the initial troubles are resolved.

i would say initial troubles are resolved once we're in Linus' tree :)
-mike
