Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbYHVO2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbYHVO2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 10:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbYHVO2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 10:28:32 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:46904 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbYHVO2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 10:28:32 -0400
Date: Fri, 22 Aug 2008 11:28:38 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca, mingo@elte.hu
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080822112838.75fef782@doriath.conectiva>
In-Reply-To: <48ADDF4F.2020401@zytor.com>
References: <20080820162925.75a5e064@doriath.conectiva>
	<48ADDF4F.2020401@zytor.com>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 21 Aug 2008 14:34:07 -0700
"H. Peter Anvin" <hpa@zytor.com> escreveu:

| > 
| >  Does this look like a kernel bug?
| > 
| 
| No, it looks like a very common virtualizer bug.  Does the attached 
| patch work for you?

 Unfortunately it does not.

-- 
Luiz Fernando N. Capitulino
