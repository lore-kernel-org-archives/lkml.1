Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbZFHVwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbZFHVwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 17:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZFHVwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 17:52:35 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57235 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbZFHVwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 17:52:34 -0400
Message-ID: <4A2D8823.40207@felter.org>
Date: Mon, 08 Jun 2009 16:52:35 -0500
From: Wes Felter <wesley@felter.org>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Kallol Biswas <nucleodyne@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: looking for ideas on VM related research projects
References: <438397970906072249pe76fafdj49626f20eea31eab@mail.gmail.com>
In-Reply-To: <438397970906072249pe76fafdj49626f20eea31eab@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kallol Biswas wrote:
> Hi,
>    I have a strong team of good, energetic and young kernel engineers
> and research scholar and I am looking for ideas on linux virtual
> memory related research projects for them.

There are some recent research projects that have not been integrated 
into Linux:

http://www.usenix.org/events/hotos09/tech/full_papers/saxena/saxena_html/
http://www.usenix.org/events/osdi08/tech/full_papers/gupta/gupta_html/index.html

I suspect that a combination of difference engine, compressed caching, 
and flash swapping could really benefit some environments.

Wes Felter - wesley@felter.org
