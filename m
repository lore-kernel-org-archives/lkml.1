Return-Path: <linux-kernel-owner+w=401wt.eu-S1764248AbXFAUE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764248AbXFAUE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762957AbXFAUEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:04:23 -0400
Received: from pool-151-205-99-173.ny325.east.verizon.net ([151.205.99.173]:56732
	"HELO gatworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762930AbXFAUEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:04:22 -0400
Message-ID: <46607BC5.4070408@gatworks.com>
Date: Fri, 01 Jun 2007 16:04:21 -0400
From: Uncle George <netbeans@gatworks.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: Re: SELECT() returns 1 But FIONREAD says (Input/output error)
References: <MDEHLPKNGKAHNMBLJOLKCEBMEEAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKCEBMEEAC.davids@webmaster.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz wrote:
>> The misunderstanding is from the docs.
>> The select() does not report device errors.
>> Select will just "more precisely, to see if a read will not block".
> 
> This is a much slighter misunderstanding. The result of the 'select'
> function tells you nothing about what a particular 'read' will or will not
> do. 
The docs 'precisely' says that it does. I'm sorry if you cannot trouble 
yourself to read the man pages to address your issues with the correct 
functionality of the select call.

Maybe you can address your issues and concerns with the documentation 
folks.

thanks again.
