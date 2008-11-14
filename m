Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbYKNMcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbYKNMcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 07:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYKNMcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 07:32:41 -0500
Received: from smtp.movial.fi ([62.236.91.34]:58517 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbYKNMck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 07:32:40 -0500
Message-ID: <491D6FE7.3080404@movial.fi>
Date: Fri, 14 Nov 2008 14:32:39 +0200
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Organization: Movial Creative Technologies
User-Agent: Icedove 1.5.0.14eol (X11/20080724)
MIME-Version: 1.0
To: Simon Arlott <simon@fire.lp0.eu>
CC: Fabio Comolli <fabio.comolli@gmail.com>, Bernhard Walle <bwalle@suse.de>,
       james.bottomley@steeleye.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow SCSI_WAIT_SCAN to be deselected
References: <1226585472-12559-1-git-send-email-bwalle@suse.de>    <b637ec0b0811130618o2f76e34bh17055f2f165d89a5@mail.gmail.com>    <491C3813.1070305@movial.fi> <0cff1148a04c9f90c98e26eff6e0bfc968e4574c@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
In-Reply-To: <0cff1148a04c9f90c98e26eff6e0bfc968e4574c@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Arlott wrote:
> On Thu, November 13, 2008 14:22, Dmitri Vorobiev wrote:
>> Fabio Comolli wrote:
>>> So I'm not the only one :-)
>>> Please see this thread:
>>>
>>> http://lkml.org/lkml/2008/10/22/355
>> See also:
>>
>> http://marc.info/?l=linux-scsi&m=122538386519971&w=2
>> http://marc.info/?l=linux-scsi&m=122539443509753&w=2
> 
> I suggest reading http://lkml.org/lkml/2007/5/13/75.
> 
> Basically, if you want to get rid of it you need to provide
> a viable alternative.

Blocking read on a character device or a /proc file? A new system call (this is a bit overkill, of course, but strictly speaking it _is_ an alternative)?

Dmitri

> 

