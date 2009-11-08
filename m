Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbZKHTwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbZKHTwa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 14:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbZKHTwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 14:52:30 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:36261 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbZKHTw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 14:52:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TH1D/D4J6y7N/1r670rYUzeJM1Trg+0qRyIcoRQ8N+rBrMF1olW6HFkS2kISIhrl1T
         JpVhzFUfQajweHpu9htj6GVCjkvVEopQptnKgPVi9v+wNepzZncCclO7YLWF84pdKQ1v
         +qn3Q+52MnNOS2ehbzRgS1m56qElTAZ6vSFpM=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0909260811470.19017@localhost>
References: <alpine.LFD.2.00.0909260811470.19017@localhost>
Date: Sun, 8 Nov 2009 17:52:33 -0200
Message-ID: <a4c8a6d00911081152l71fb61e4geaa7661327594494@mail.gmail.com>
Subject: Re: how best to report results of my kernel tree scanning scripts?
From: Thiago Farina <tfransosi@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On Sat, Sep 26, 2009 at 10:16 AM, Robert P. J. Day
<rpjday@crashcourse.ca> wrote:
>
>  since the merge window appears to be ready to close fairly soon(?),
> i'm prepping to run my scanning scripts once again to identify (among
> other things):
>   * unused Kconfig CONFIG variables
>   * references to CONFIG_ variables that don't even exist (both in
>     source files and Makefiles)
>   * references to non-existent header files

I'm following your reports from:
http://www.crashcourse.ca/wiki/index.php/The_style_script, and I'm
fixing some of them.

I would ask you if you could make those scripts available. So I can
run them into the latest linux tree.

Thanks in advance for providing this reports.
