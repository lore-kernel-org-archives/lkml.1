Return-Path: <linux-kernel-owner+w=401wt.eu-S965581AbXAWXUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965581AbXAWXUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 18:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965591AbXAWXUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 18:20:12 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:38459 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965581AbXAWXUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 18:20:10 -0500
Date: Tue, 23 Jan 2007 17:18:43 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SATA exceptions with 2.6.20-rc5
In-reply-to: <fa.rI60BGlFbSyfLyumqmgiOfDqCI4@ifi.uio.no>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Larry Walton <lwalton@real.com>, B.Steinbrink@gmx.de,
       s0348365@sms.ed.ac.uk, pomac@vapor.com, chunkeey@web.de,
       Jeff Garzik <jeff@garzik.org>
Message-id: <45B697D3.4070707@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.1kBz5luWz8nR0lLqm1VD4hZZYdw@ifi.uio.no>
 <fa.QZxgjxcwtENaZNY24NMTlKBSgIM@ifi.uio.no>
 <fa.fkPTbUGmKc/1pt0eD6TE4d02n+Q@ifi.uio.no>
 <fa.6iQt5OtHZ3x5w8eYbLxwULhLTJ0@ifi.uio.no>
 <fa.1aqo3IxNGJClHcBVZNTagX6bL9o@ifi.uio.no>
 <fa.rI60BGlFbSyfLyumqmgiOfDqCI4@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Walton wrote:
> The last patch (sata_nv-force-int-dev-in-interrupt.patch) 
> seems to have fix the problem.  Much appreciated, 
> thank you. I'd consider it a must have in 2.6.20.

Can any of the rest of you that have been seeing this problem also 
confirm that this fixes it?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

