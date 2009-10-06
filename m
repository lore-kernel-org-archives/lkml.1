Return-Path: <linux-kernel-owner+w=401wt.eu-S932205AbZJFLde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbZJFLde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 07:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932137AbZJFLdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 07:33:33 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:58353 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbZJFLdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 07:33:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=Zlq4Bh9D5gPwiO0IoI9sGgcEXo9AyBK7ol5OV0FG+k4VOyS6N8WQAM9HrcR2Pj5fFl
         l8J3KTukBzgpRe9fE9ki/PCgZN5mtmSd5UFsyI1T9EH/h9D8AR7AEX/kMshiVdswt3TK
         nPQze3DjcWW8gcmGc3uoBPrRvCnmjmhWE0eUA=
MIME-Version: 1.0
Reply-To: gabe@blackfam.net
In-Reply-To: <20091005170926.7e34368c@jbarnes-g45>
References: <8a15eb2b0909221201k70b9e9darc6fda53f87bfae29@mail.gmail.com>
	 <20090922211101.076e9763@infradead.org>
	 <8a15eb2b0909221237s5d3e408do4e3bed8aaaa337a8@mail.gmail.com>
	 <20090922220747.702c3b11@infradead.org>
	 <20091005170926.7e34368c@jbarnes-g45>
Date: Tue, 6 Oct 2009 06:32:54 -0500
Message-ID: <8a15eb2b0910060432m3c062776md718ea19baf19a3f@mail.gmail.com>
Subject: Re: TI PCIe-PCI bridge quirks
From: Gabe Black <gabebblack@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 5, 2009 at 7:09 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
> Gabe, did you figure out how to do this?  Do you need any more help?
>

Yes, I have a patch tested and ready to go.  Unfortunately, I'm
waiting on approval from the company I work at to submit it.  I really
don't understand what they are so scared of; but they own me :-(

Hopefully it won't be much longer before they let me submit.

-- Gabe
